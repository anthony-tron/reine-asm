#include <iostream>

using namespace std;

namespace
{
    const unsigned N = 8;
    unsigned Colonne[N];

    bool SansConflit(const unsigned &Lign, const unsigned &Coln)
    {
        unsigned i1, j1, i2 = Lign, j2 = Coln;
        for (unsigned k = 0; k < Lign; ++k)
        {
            i1 = k;
            j1 = Colonne[k];
            if ((i1 == i2)                   // meme olonne
                || (j1 == j2)                // meme ligne
                || ((i1 - j1) == (i2 - j2))  // meme diagonale
                || ((i1 + j1) == (i2 + j2))) // meme diagonale
                return false;
        }
        return true;
    } // SansConflit ()

    void test1()
    {
        Colonne[0] = 1;
        Colonne[1] = 2;
        Colonne[2] = 3;
        Colonne[3] = 4;
        Colonne[4] = 5;
        Colonne[5] = 6;
        Colonne[6] = 7;
        Colonne[7] = 1;

        for (unsigned i = 0; i < N; ++i)
        {
            for (unsigned j = 0; j < N; ++j)
                cout << SansConflit(i, j) << ' ';

            cout << endl;
        }
    }
} // namespace

int main()
{
    test1();
    return 0;
}