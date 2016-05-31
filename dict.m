clc;

y1 = (1:20)';
y1 = y1 ./ norm(y1);
y2 = (linspace(15, 40, 20))';
y2 = y2 ./ norm(y2);
y3 = (13:32)';
y3 = y3 ./ norm(y3);

% ƒmƒCƒY‚Í0.05‚®‚ç‚¢‚Ü‚Å
Y = y1*rand(1) + y2*rand(1) + y3*rand(1) + 0.05*randn(20,1);
%Y = Y ./ norm(Y);
for i=2:1500
    yi = y1*rand(1) + y2*rand(1) + y3*rand(1) + 0.05*randn(20,1);
    %yi = yi ./ norm(yi);
    Y = [Y yi];
end

% D = Y(:,(1:50));
% for i=1:50
%     D(:,i) = D(:,i)./norm(D(:,i));
% end

D = rand(20,50);
for i=1:50
    D(:,i) = D(:,i)./norm(D(:,i));
end

for J=1:80
    
X = omp(D, Y, D'*D, 3);
for i=1:50
    idx = find(X(i,:));
    if isempty(idx)
        continue;
    end
    omega = zeros(1500, size(idx,2));
    for j=1:size(idx,2)
        omega(idx(j), j) = 1;
    end
    
    Ek = Y - D*X + D(:,i)*X(i,:);
    Ekr = Ek*omega;
    
    [U, S, V] = svd(Ekr);
    D(:,i) = U(:,1);
    X(i,:) = (omega*S(1,1)*V(:,1))';    
    
end

fprintf('Iteration %d: %f\n', J, norm(Y-D*X));

end

disp('Results:')
min_ans = 1e10;
for i=1:50
    if min_ans > norm(D(:,i)-y1)
        min_ans = norm(D(:,i)-y1);
        nearest = D(:,i);
    end
end
fprintf('y1: %f\n', 1-y1'*nearest);

min_ans = 1e10;
for i=1:50
    if min_ans > norm(D(:,i)-y2)
        min_ans = norm(D(:,i)-y2);
        nearest = D(:,i);
    end
end
fprintf('y2: %f\n', 1-y2'*nearest);

min_ans = 1e10;
for i=1:50
    if min_ans > norm(D(:,i)-y3)
        min_ans = norm(D(:,i)-y3);
        nearest = D(:,i);
    end
end
fprintf('y3: %f\n', 1-y3'*nearest);