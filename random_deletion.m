A = test_dataset;
cc = size(A,1);
id = randperm(cc);
A(id(1:3376),:) = [];