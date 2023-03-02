import matplotlib.pyplot as plt

xtics = [1,3,6,9,12,15]
ytics = [15,20,25,30,35,40,45]
bleu = [20.4, 25.5, 30.7, 32.3, 32.7, 32.8]
dal = [2.3, 3.7, 6.3, 8.9, 11.3, 13.3]
al = [1.8, 3.0, 5.4, 8.1, 10.6, 12.8]
#ap = [0.6, 0.7, 0.8, 0.9, 0.9, 0.9]
fig1, ax1 = plt.subplots()

ax1.axis([0,16,15,45])
ax1.plot(al, bleu,"-o", label = "AL", linewidth=1)
ax1.plot(dal, bleu,"-o", label = "DAL", linewidth=1)
ax1.axhline(y = 34, color = 'c', linestyle = ':')

ax1.set_xticks(xtics)
ax1.set_yticks(ytics)

ax1.text(0, 43.5,'BLEU(WMT13)', fontsize=15)
ax1.text(13.2, 15.2,'Latency', fontsize=15)
ax1.text(6, 27,'AL', fontsize=15)
ax1.text(4, 32,'DAL', fontsize=15)
ax1.text(12.4, 34.6,'V4-Offline', fontsize=15)

plt.grid(True)
plt.savefig('../resources/onlineres.png')
#plt.show()
