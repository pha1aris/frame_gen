module Vote_Calculator #(
    parameter integer SYNC_REPETITION = 8,
    parameter integer VOTE_THRESHOLD  = 2
)(
    input  wire [SYNC_REPETITION-1:0] match_votes_i,
    output wire                       sync_match_o,
    output wire [$clog2(SYNC_REPETITION+1)-1:0] total_votes     // debug-friendly
);

    localparam CNT_WIDTH = $clog2(SYNC_REPETITION+1);

    // next power of 2
    function integer next_pow2;
        input integer v; integer t;
        begin
            t = 1;
            while (t < v) t = t << 1;
            next_pow2 = t;
        end
    endfunction

    localparam integer P2 = next_pow2(SYNC_REPETITION);
    localparam integer LEVELS = $clog2(P2);

    // level0 padded inputs (width CNT_WIDTH)
    wire [CNT_WIDTH-1:0] level0 [0:P2-1];
    genvar i, l, j;
    generate
        for (i = 0; i < P2; i = i + 1) begin : GEN_L0
            if (i < SYNC_REPETITION) begin
                assign level0[i] = {{(CNT_WIDTH-1){1'b0}}, match_votes_i[i]}; // extend to CNT_WIDTH
            end else begin
                assign level0[i] = {CNT_WIDTH{1'b0}};
            end
        end
    endgenerate

    // sums[level][index]
    // Using multi-dim wire; most tools support it.
    wire [CNT_WIDTH-1:0] sums [0:LEVELS][0:P2-1];

    // connect level0
    generate
        for (i = 0; i < P2; i = i + 1) begin : LV0_ASSIGN
            assign sums[0][i] = level0[i];
        end

        for (l = 0; l < LEVELS; l = l + 1) begin : LEVEL_LOOP
            for (j = 0; j < (P2 >> (l+1)); j = j + 1) begin : NODE
                assign sums[l+1][j] = sums[l][2*j] + sums[l][2*j+1];
            end
        end
    endgenerate

    assign total_votes = sums[LEVELS][0];
    assign sync_match_o = (total_votes >= VOTE_THRESHOLD);

endmodule
