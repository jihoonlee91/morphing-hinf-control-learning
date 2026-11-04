classdef SmokeTest < matlab.unittest.TestCase
    % Fast checks that a fresh MATLAB can trim and linearize the span-sweep morphing UAV
    % and synthesize a mixed-sensitivity H-infinity controller.
    % Run from the repository root:  results = runtests("tests")
    % CI runs this on every push (.github/workflows/matlab.yml).

    properties (Constant)
        RepoDir = fileparts(fileparts(mfilename("fullpath")))
    end

    methods (TestClassSetup)
        function loadModelData(testCase)
            here = pwd;
            testCase.addTeardown(@() cd(here));
            cd(testCase.RepoDir);
            addpath(testCase.RepoDir);
            addpath(genpath(fullfile(testCase.RepoDir, "LPVToolsV1.0")));
            evalin("base", "spec_data; aero_data");   % the model data are globals
        end
    end

    methods (Test)
        function trimsAndLinearizesAcrossMorphing(testCase)
            % Corners and center of the morphing grid at the design condition (20 m/s, 300 m).
            for eta = [0 0; 1 0; 0 1; 1 1; 0.5 0.5].'
                [G, alp] = lti_model(20, 300, eta(1), eta(2));
                testCase.verifySize(G.A, [4 4]);
                testCase.verifyTrue(all(isfinite(G.A(:))) && all(isfinite(G.B(:))), ...
                    sprintf("non-finite linear model at eta = [%g %g]", eta));
                testCase.verifyLessThan(abs(rad2deg(alp)), 10, "trim angle of attack outside the +/-10 deg bound");
            end
        end

        function mixedSensitivitySynthesisRuns(testCase)
            % Short-period plant (elevator -> pitch rate) at the center of the morphing
            % range, built from the linear model the same way main.m does.
            V = 20;
            G = lti_model(V, 300, 0.5, 0.5);
            Zalpha = G.A(2,2)*V;  Zdelta = G.B(2,2)*V;
            Malpha = G.A(3,2);    Mdelta = G.B(3,2);
            Gsp = ss([Zalpha/V 1; Malpha 0], [Zdelta/V; Mdelta], [0 1], 0);
            W1 = makeweight(100, [1 1], 0.1);    % tracking: high gain at low frequency
            W3 = makeweight(0.1, [20 1], 10);    % robustness: roll off above ~20 rad/s
            [K, CL, gamma] = mixsyn(Gsp, W1, [], W3);
            testCase.verifyNotEmpty(K);
            testCase.verifyTrue(isfinite(gamma) && gamma > 0);
            testCase.verifyTrue(isstable(CL), "mixed-sensitivity closed loop is unstable");
        end
    end
end
