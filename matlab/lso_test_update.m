function lso_test_update(max_isles)
% LSO_TEST_UPDATE(MAX_ISLES)
% 
% Description
%     Test LSO_TEST by attempting to match a topology starting with an
%     empty grid.
% 
% Inputs
%     MAX_ISLES: Non-negative integer.
%         Maximum number of islands to nucleate at each iteration.
% 
% Example
%     lso_test_update(1); % One island nucleated per iteration.
%     lso_test_update(100); % 100 islands nucleated per iteration.


dims = randi(10, [1 2])+10; % Pick dimensions of initial grid.
d = 4; % Interpolation factor, for larger characteristic feature size.

% Build target structure.
phi_target = interp2(randn(dims), [1:d^-1:dims(2)]', 1:d^-1:dims(1));
p_target = lso_fracfill(phi_target);

% Actual dimensions of the grid.
dims = size(phi_target);


% Setup the optimization.
phi = -ones(dims); % Start with an empty grid.
dp = @(p) (p_target - p);
err = @(p) norm(p_target(:) - p(:));

for k = 1 : 100 
    % Plot topologies.
    subplot 121; lso_plot(phi); title('dynamic structure');
    subplot 122; lso_plot(phi_target); title('target structure');
    axis equal tight;
    pause(0.4);

    % Update the structure.
    phi = lso_update(phi, dp(lso_fracfill(phi)), err, max_isles, 2.^[-10:10]);
    phi = lso_quickreg(phi);
end

