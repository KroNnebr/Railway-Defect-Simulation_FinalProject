function count = poissonSample(lambda)

if lambda <= 0
    count = 0;
    return;
end

threshold = exp(-lambda);
product = 1;
count = 0;

while product > threshold
    count = count + 1;
    product = product * rand();
end

count = count - 1;
end