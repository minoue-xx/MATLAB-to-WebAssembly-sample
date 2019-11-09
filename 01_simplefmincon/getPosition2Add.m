function xlong = getPosition2Add(target_pf, price, position)

% Specify the Dimensions and Data Types
assert(isa(target_pf, 'double'));
assert(isa(price, 'double'));
assert(isa(position, 'double'));
assert(all( size(target_pf) == [ 1, 10 ]))
assert(all( size(price) == [ 1, 10 ]))
assert(all( size(position) == [ 1, 10 ]))


idx = target_pf > 0;
target_pf = target_pf(idx);
price = price(idx);
position = position(idx);
N = sum(idx);

% それぞれの銘柄いくつ購入すればターゲットとする保有割合に近づくかを求めます。 その際の制約は Cost：合計何ドルまでの購入とするか ここでは 2k
% (約 20万円）とします。

Cost = 2e3; % $2k

% 線形不等式制約（合計コストが Cost 以下）
A = price;
b = Cost;
% 線形等式制約はなし
Aeq = [];
beq = [];
% 購入数の上下限
lb = zeros(1,N);
ub = inf(1,N);
% 初期値は 0。
x0 = zeros(1,N);

options = optimoptions('fmincon','Algorithm','sqp');

% 目的関数は getDiff で定義されています。
% ターゲットの保有割合との誤差二乗和平方根を最小とすることを目指します。
objfun = @(x2add) getDiff(x2add,price,position,target_pf);
x = fmincon(objfun,x0,A,b,Aeq,beq,lb,ub,[],options);

% fmincon を使用
% 本来は整数問題ですが実数で株数を求めた後、端数は無視します。
% 購入株数が多ければそこまで問題にはならないため。
% もちろん購入株数が少ない場合は影響があるため調整は行っているみたいですが、
% この方法はロボアドバイザー THEO も同じ（要引用）
% 購入株数の小数点以下切り捨て
xlong = zeros(1,10);
xlong(1:N) = floor(x);

end

function errorRMS = getDiff(position2add,marketvalue,position,target_pf)
newTotal = marketvalue.*(position2add+position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - target_pf).^2 ) );
end