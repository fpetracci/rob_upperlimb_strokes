function gram = gramian_comp(h, W, x, x1, x2)

gram = integral(subs(derivarive(h, x)', x, x1)*W*subs(derivarive(h, x)', x, x1), 0, T)