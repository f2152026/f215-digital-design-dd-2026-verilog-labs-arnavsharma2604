// cla4.v
// Gate-level 4-bit carry-lookahead adder

module cla4(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;
    wire c1, c2, c3, c4;

    // Propagate and generate signals
    xor #(2) P0 (p0, a[0], b[0]);
    xor #(2) P1 (p1, a[1], b[1]);
    xor #(2) P2 (p2, a[2], b[2]);
    xor #(2) P3 (p3, a[3], b[3]);

    and #(2) G0 (g0, a[0], b[0]);
    and #(2) G1 (g1, a[1], b[1]);
    and #(2) G2 (g2, a[2], b[2]);
    and #(2) G3 (g3, a[3], b[3]);

    // Carry lookahead equations

    // c1 = g0 + p0.cin
    wire c1_g0, c1_p0;
    and #(2) C1A (c1_g0, g0);
    and #(2) C1B (c1_p0, p0, cin);
    or  #(2) C1O (c1, c1_g0, c1_p0);

    // c2 = g1 + p1.g0 + p1.p0.cin
    wire c2_g1, c2_p1g0, c2_p1p0cin;
    and #(2) C2A (c2_g1, g1);
    and #(2) C2B (c2_p1g0, p1, g0);
    and #(2) C2C (c2_p1p0cin, p1, p0, cin);
    or  #(2) C2O (c2, c2_g1, c2_p1g0, c2_p1p0cin);

    // c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
    wire c3_g2, c3_p2g1, c3_p2p1g0, c3_p2p1p0cin;
    and #(2) C3A (c3_g2, g2);
    and #(2) C3B (c3_p2g1, p2, g1);
    and #(2) C3C (c3_p2p1g0, p2, p1, g0);
    and #(2) C3D (c3_p2p1p0cin, p2, p1, p0, cin);
    or  #(2) C3O (c3, c3_g2, c3_p2g1, c3_p2p1g0, c3_p2p1p0cin);

    // c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0
    //      + p3.p2.p1.p0.cin
    wire c4_g3, c4_p3g2, c4_p3p2g1;
    wire c4_p3p2p1g0, c4_p3p2p1p0cin;

    and #(2) C4A (c4_g3, g3);
    and #(2) C4B (c4_p3g2, p3, g2);
    and #(2) C4C (c4_p3p2g1, p3, p2, g1);
    and #(2) C4D (c4_p3p2p1g0, p3, p2, p1, g0);
    and #(2) C4E (c4_p3p2p1p0cin, p3, p2, p1, p0, cin);

    or #(2) C4O (
        c4,
        c4_g3,
        c4_p3g2,
        c4_p3p2g1,
        c4_p3p2p1g0,
        c4_p3p2p1p0cin
    );

    // Sum bits: sum[i] = p[i] ^ c[i]
    xor #(2) S0 (sum[0], p0, cin);
    xor #(2) S1 (sum[1], p1, c1);
    xor #(2) S2 (sum[2], p2, c2);
    xor #(2) S3 (sum[3], p3, c3);

    assign #(2) cout = c4;

endmodule