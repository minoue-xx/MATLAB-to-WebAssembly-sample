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

% ���ꂼ��̖��������w������΃^�[�Q�b�g�Ƃ���ۗL�����ɋ߂Â��������߂܂��B ���̍ۂ̐���� Cost�F���v���h���܂ł̍w���Ƃ��邩 �����ł� 2k
% (�� 20���~�j�Ƃ��܂��B

Cost = 2e3; % $2k

% ���`�s��������i���v�R�X�g�� Cost �ȉ��j
A = price;
b = Cost;
% ���`��������͂Ȃ�
Aeq = [];
beq = [];
% �w�����̏㉺��
lb = zeros(1,N);
ub = inf(1,N);
% �����l�� 0�B
x0 = zeros(1,N);

options = optimoptions('fmincon','Algorithm','sqp');

% �ړI�֐��� getDiff �Œ�`����Ă��܂��B
% �^�[�Q�b�g�ۗ̕L�����Ƃ̌덷���a���������ŏ��Ƃ��邱�Ƃ�ڎw���܂��B
objfun = @(x2add) getDiff(x2add,price,position,target_pf);
x = fmincon(objfun,x0,A,b,Aeq,beq,lb,ub,[],options);

% fmincon ���g�p
% �{���͐������ł��������Ŋ��������߂���A�[���͖������܂��B
% �w��������������΂����܂Ŗ��ɂ͂Ȃ�Ȃ����߁B
% �������w�����������Ȃ��ꍇ�͉e�������邽�ߒ����͍s���Ă���݂����ł����A
% ���̕��@�̓��{�A�h�o�C�U�[ THEO �������i�v���p�j
% �w�������̏����_�ȉ��؂�̂�
xlong = zeros(1,10);
xlong(1:N) = floor(x);

end

function errorRMS = getDiff(position2add,marketvalue,position,target_pf)
newTotal = marketvalue.*(position2add+position);
newPF = newTotal/sum(newTotal);
errorRMS = sqrt(sum( (newPF - target_pf).^2 ) );
end