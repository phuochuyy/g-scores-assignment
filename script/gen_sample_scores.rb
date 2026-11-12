# Generates realistic-looking (fake) Vietnamese THPT exam scores for g-scores-assignment.
# Usage: ruby gen_sample_scores.rb OUTPUT.csv [COUNT]
require "csv"

out   = ARGV.fetch(0)
count = (ARGV[1] || 1000).to_i
rng   = Random.new(2024) # deterministic

def gauss(rng)
  # Box-Muller
  Math.sqrt(-2 * Math.log(1 - rng.rand)) * Math.cos(2 * Math::PI * rng.rand)
end

# mean / sd roughly in line with published national averages; step = scoring granularity
SUBJECTS = {
  "toan"      => { mean: 6.45, sd: 1.45, step: 0.2  },
  "ngu_van"   => { mean: 7.20, sd: 1.20, step: 0.25 },
  "ngoai_ngu" => { mean: 5.50, sd: 1.80, step: 0.2  },
  "vat_li"    => { mean: 6.65, sd: 1.45, step: 0.25 },
  "hoa_hoc"   => { mean: 6.65, sd: 1.55, step: 0.25 },
  "sinh_hoc"  => { mean: 6.25, sd: 1.25, step: 0.25 },
  "lich_su"   => { mean: 6.55, sd: 1.55, step: 0.25 },
  "dia_li"    => { mean: 7.15, sd: 1.25, step: 0.25 },
  "gdcd"      => { mean: 8.15, sd: 1.00, step: 0.25 }
}.freeze
KHTN = %w[vat_li hoa_hoc sinh_hoc].freeze
KHXH = %w[lich_su dia_li gdcd].freeze
LANGS = [ [ "N1", 950 ], [ "N4", 15 ], [ "N6", 15 ], [ "N3", 10 ], [ "N7", 5 ], [ "N2", 3 ], [ "N5", 2 ] ].freeze
# A spread of province codes (01 Hà Nội, 02 TP.HCM, 03 Hải Phòng, 04 Đà Nẵng, ...)
PROVINCES = [ [ 1, 30 ], [ 2, 30 ], [ 3, 8 ], [ 4, 6 ], [ 5, 2 ], [ 12, 3 ], [ 17, 4 ], [ 18, 4 ], [ 21, 5 ],
             [ 25, 3 ], [ 27, 4 ], [ 28, 6 ], [ 29, 7 ], [ 30, 4 ], [ 33, 3 ], [ 37, 3 ], [ 44, 4 ], [ 48, 3 ],
             [ 52, 3 ], [ 55, 3 ], [ 60, 2 ], [ 64, 2 ] ].freeze

def weighted(rng, pairs)
  r = rng.rand(pairs.sum(&:last))
  pairs.each { |v, w| return v if (r -= w) < 0 }
end

def score(rng, cfg, ability)
  z = 0.6 * ability + 0.8 * gauss(rng) # keeps unit variance, correlates subjects per student
  raw = (cfg[:mean] + cfg[:sd] * z).clamp(0.0, 10.0)
  ((raw / cfg[:step]).round * cfg[:step]).clamp(0.0, 10.0).round(2)
end

def fmt(v)
  return nil if v.nil?
  s = format("%.2f", v).sub(/0+\z/, "").sub(/\.\z/, "")
  s
end

seq = Hash.new(0)
CSV.open(out, "w") do |csv|
  csv << %w[sbd toan ngu_van ngoai_ngu vat_li hoa_hoc sinh_hoc lich_su dia_li gdcd ma_ngoai_ngu]
  count.times do
    prov = weighted(rng, PROVINCES)
    sbd  = format("%02d%06d", prov, seq[prov] += 1)
    ability = gauss(rng)
    gdtx    = rng.rand < 0.03                    # continuing-education candidates: no GDCD, often no foreign language
    combo   = rng.rand < 0.37 ? KHTN : KHXH      # ~63% chose social sciences
    taken   = %w[toan ngu_van] + combo
    taken << "ngoai_ngu" unless gdtx && rng.rand < 0.7
    taken.delete("gdcd") if gdtx

    row = SUBJECTS.keys.to_h { |s| [ s, taken.include?(s) ? score(rng, SUBJECTS[s], ability) : nil ] }
    # ~1% absent from one exam they registered for
    row[taken.sample(random: rng)] = nil if rng.rand < 0.01
    lang = row["ngoai_ngu"] ? weighted(rng, LANGS) : nil

    csv << [ sbd, *SUBJECTS.keys.map { |s| fmt(row[s]) }, lang ]
  end
end
puts "wrote #{count} rows to #{out}"
