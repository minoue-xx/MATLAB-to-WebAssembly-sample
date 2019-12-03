% Copyright (c) 2019 Michio Inoue
target_pf = [0.275, 0.125, 0.2, 0.1, 0.1, 0.15, 0.05, 0, 0, 0];
price = [155.83, 90.4, 42.78, 42.50, 142.56, 112.93, 39.23, 0, 0, 0];
position = [12, 20, 40, 15, 6, 18, 12, 0, 0, 0];
xlong = getPosition2Add(target_pf, price, position)