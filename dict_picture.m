clc;
Y = zeros(64, 11000);
for i=1:11000
    yi = imread(sprintf('./patch/patch%d.png',i));
    yi = reshape(yi, numel(yi), 1);
    yi = im2double(yi);
    Y(:,i) = yi;
end
fprintf('読み込み終わり\n');

% 最初の辞書の要素は1/64(パッチサイズ)
% 他の要素は平均値0
% 平均値引いてからl^2ノルムで割る
D = rand(64, 441);
D(:,1) = 1/64 * ones(64,1);
D(:,1) = D(:,1)./norm(D(:,1));
for i=2:441
    D(:,i) = D(:,i) - mean(D(:,i));
    D(:,i) = D(:,i)./norm(D(:,i));
end

for J=1:80
    %X = omp(D, Y, D'*D, 10);
    tic;
    X = omp(D'*Y, D'*D, 10);
    for i=1:441
        idx = find(X(i,:));
        if isempty(idx)
            continue;
        end
        omega = zeros(11000, size(idx,2));
        for j=1:size(idx,2)
            omega(idx(j), j) = 1;
        end
    
        Ek = Y - D*X + D(:,i)*X(i,:);
        Ekr = Ek*omega;
    
        [U, S, V] = svd(Ekr);
        D(:,i) = U(:,1);
        X(i,:) = (omega*S(1,1)*V(:,1))';
    end
    elapsedTime = toc;
    fprintf('Iteration %d: %f, ElapsedTime: %f\n', J, norm(Y-D*X), elapsedTime);
end