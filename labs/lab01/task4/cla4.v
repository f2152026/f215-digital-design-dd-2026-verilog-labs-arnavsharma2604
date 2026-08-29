// cla4.v
// (Carried forward from Task 3 -- paste in your completed, delay-annotated
// version.)
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

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

    xor #(2) P0 (p0, a[0], b[0]);
    xor #(2) P1 (p1, a[1], b[1]);
    xor #(2) P2 (p2, a[2], b[2]);
    xor #(2) P3 (p3, a[3], b[3]);

    and #(2) G0 (g0, a[0], b[0]);
    and #(2) G1 (g1, a[1], b[1]);
    and #(2) G2 (g2, a[2], b[2]);
    and #(2) G3 (g3, a[3], b[3]);

    wire c1_g0, c1_p0;
    and #(2) C1A (c1_g0, g0);
    and #(2) C1B (c1_p0, p0, cin);
    or  #(2) C1O (c1, c1_g0, c1_p0);

    wire c2_g1, c2_p1g0, c2_p1p0cin;
    and #(2) C2A (c2_g1, g1);
    and #(2) C2B (c2_p1g0, p1, g0);
    and #(2) C2C (c2_p1p0cin, p1, p0, cin);
    or  #(2) C2O (c2, c2_g1, c2_p1g0, c2_p1p0cin);

    wire c3_g2, c3_p2g1, c3_p2p1g0, c3_p2p1p0cin;
    and #(2) C3A (c3_g2, g2);
    and #(2) C3B (c3_p2g1, p2, g1);
    and #(2) C3C (c3_p2p1g0, p2, p1, g0);
    and #(2) C3D (c3_p2p1p0cin, p2, p1, p0, cin);
    or  #(2) C3O (c3, c3_g2, c3_p2g1, c3_p2p1g0, c3_p2p1p0cin);

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
        c4_p3p2g1,
        c4_p3p2p1g0,
        c4_p3p2p1p0cin
    );

    xor #(2) S0 (sum[0], p0, cin);
    xor #(2) S1 (sum[1], p1, c1);
    xor #(2) S2 (sum[2], p2, c2);
    xor #(2) S3 (sum[3], p3, c3);

assign cout = c4;
endmodule


