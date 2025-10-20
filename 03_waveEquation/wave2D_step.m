function u_next = wave2D_step(u, u_prev, c, dt, dx, dy, damping)
% 2D Wave equation step
% u      : current wave state [ny x nx]
% u_prev : previous wave state [ny x nx]
% c, dt, dx, dy : wave parameters
% damping : damping factor
%
% returns:
%   u_next : next wave state [ny x nx]
%   u      : current becomes previous
%   u_prev : previous becomes current

[ny, nx] = size(u);
u_next = zeros(ny, nx);

iddx = 1/(dx^2);
iddy = 1/(dy^2);
ccddt = c^2*dt^2;
for i = 2:nx-1
    for j = 2:ny-1
        lap = (u(j,i+1) - 2*u(j,i) + u(j,i-1))*iddx + ...
              (u(j+1,i) - 2*u(j,i) + u(j-1,i))*iddy;
        u_next(j,i) = 2*u(j,i) - u_prev(j,i) + ccddt*lap;
        u_next(j,i) = u_next(j,i) * damping;
    end
end

% 固定境界条件
u_next(1,:) = 0;
u_next(ny,:) = 0;
u_next(:,1) = 0;
u_next(:,nx) = 0;

end
