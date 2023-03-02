import numpy as np
import matplotlib.pyplot as plt

x1s = np.linspace(-0.2, 1.2, 100)
x2s = np.linspace(-0.2, 1.2, 100)
x1, x2 = np.meshgrid(x1s, x2s)

plt.figure()

# plt.subplot(121)
z1=[[0.]*100]*100
plt.contour(x1, x2, z1)
plt.plot(0, 0, "ks", markersize=10)
plt.plot(1, 0, "ks", markersize=10)
plt.plot(1, 1, "ks", markersize=10)
plt.plot(0, 1, "co", markersize=10)
#plt.plot([0, 1], [1, 0], "co", markersize=10)
#plt.title("Activation function: heaviside", fontsize=14)
plt.grid(True)
plt.savefig("../resources/xorsolved1.png")
#plt.savefig("xor-problem.pdf")
plt.show()
