def RSA(p, len_M):
    global e, C, ZmodN # Global variables
    
    temp = []
    for x in p:
        temp.append('{0:08b}'.format(ord(x)))

    bin_p = ''.join(temp)
    beta = 1
    eps = beta / 7
    flag = 0
    for length_M in range(0, len_M+1, 4):
        P.<M> = PolynomialRing(ZmodN)
        polynomial = ((int(bin_p, 2)<<length_M) + M)^e - C                   
        m = ceil(1**2 / (polynomial.degree() * (1/7))) # beta = 1, eps = 1/7
        t = floor(polynomial.degree() * m * ((1/beta) - 1))    
        X = ceil(N**((1**2/polynomial.degree()) - (1/7)))  

        roots = coppersmith(polynomial, N, beta, m, t, X) # Calling function coppersmith to get the roots

        if roots:
            print("The correct root is :", bin(roots[0])[2:])
            flag = 1
            break
    if flag==0:
        print('Solution not found')

def coppersmith(polynomial, modulus, beta, m, t, X):
    
    polynomial = polynomial.change_ring(ZZ)
	
    x = polynomial.change_ring(ZZ).parent().gen()
    degree = polynomial.degree()
   
    lis = [] # Polynomials
    for i in range(m):
        for j in range(degree):
            lis+=[(x * X)**j * modulus**(m - i) * polynomial(x * X)**i]
    for i in range(t):
        lis+=[(x * X)**i * polynomial(x * X)**m]
	
	
    y = degree * m + t
    lattice_B = Matrix(ZZ, y) # Lattice B

    for i in range(y):
        for j in range(i+1):
            lattice_B[i, j] = lis[i][j]
   
    lattice_B = lattice_B.LLL() # LLL

    polynomial = 0
    for i in range(y):
        polynomial += x**i * lattice_B[0, i] / X**i # shortest vector

    possible_roots = polynomial.roots() # Stores the possible roots
    
    roots = [] # true roots
    for root in possible_roots:
        if root[0].is_integer():
            result = polynomial(ZZ(root[0]))
            if gcd(modulus, result) >= modulus^beta:
                roots+=[ZZ(root[0])]

    return roots

e = 5
C = 23701787746829110396789094907319830305538180376427283226295906585301889543996533410539381779684366880970896279018807100530176651625086988655210858554133345906272561027798171440923147960165094891980452757852685707020289384698322665347609905744582248157246932007978339129630067022987966706955482598869800151693
N = 84364443735725034864402554533826279174703893439763343343863260342756678609216895093779263028809246505955647572176682669445270008816481771701417554768871285020442403001649254405058303439906229201909599348669565697534331652019516409514800265887388539283381053937433496994442146419682027649079704982600857517093

ZmodN = Zmod(N);

if __name__ == "__main__":
    RSA("You see a Gold-Bug in one corner. It is the key to a treasure found by ", 200)