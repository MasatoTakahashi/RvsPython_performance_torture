using Pkg;
# Pkg.add("DataFrames");
# Pkg.add("CSV");

using Statistics;
using DataFrames;
using DataFramesMeta;
using CSV;
using Dates;

function ex1(d_transaction, d_resp_master)
    t0 = Dates.now();
    d = leftjoin(d_transaction, d_resp_master, on = :company_number);
    println(size(d));
    println(Dates.now() - t0);
    return d
end

function ex2(d)
    t0 = Dates.now();
    d2 = @linq d |>
        by(:company_number, n=length(:q), x1=sum(:q), x2=minimum(:q), x3=maximum(:q), x4=sum(:q));
    println(size(d2));
    println(Dates.now() - t0);
end

function ex3(d)
    t0 = Dates.now();
    d.tmp_ym6_prev = d.ym6 + Dates.Month(1)
    print(first(d, 10))
    d3 = @linq d |>
        leftjoin(d, on = [:tmp_ym6_prev => :ym6, :company_number => :company_number], makeunique=true);
    println(size(d3));
    println(Dates.now() - t0);
end

d_transaction = CSV.read("./dummy_transaction_data.csv", types=Dict("ym6" => String));
d_resp_master = CSV.read("./dummy_resp_master.csv", types=Dict("ym6" => String));

d_transaction.ym6 = map(x -> Dates.Date(x, "yyyymm"), d_transaction.ym6);

println(size(d_transaction));
println(size(d_resp_master));

d = ex1(d_transaction, d_resp_master);
ex2(d);
ex3(d);
