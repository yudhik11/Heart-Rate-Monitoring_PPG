function A_plus = MPinverse(A)

    matrix = ctranspose(A);
    A_plus = matrix / (A * matrix);
end