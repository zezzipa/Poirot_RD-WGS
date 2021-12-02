#!/usr/bin/perl -w
# HHT

use strict;

my $ExCIDinfile=shift @ARGV;
my $limitfile=shift @ARGV;
my $HsMinfile=shift @ARGV;
my $iterationnumber=$HsMinfile;
$iterationnumber =~ s/^[^_]*_//;
$iterationnumber =~ s/.bam_HsM.txt//;

my $name=$HsMinfile;
$name =~ s/-ready_(.*).bam_HsM.txt//;

my $Bamtoolsinfile1=$name."_samtools_stats_".$iterationnumber.".txt";
my $GATKinfile1=$name."-ready_".$iterationnumber.".bam.sample_summary";
my $GATKinfile2=$name."-ready_".$iterationnumber.".bam.sample_gene_summary";
my $outfile=$name."_qc_rapport_HHT.txt";


open OUT,">$outfile";
print OUT "*********************************************\n";
print OUT "QC rapport NGS\n";
print OUT "DNAnr: $name\n";
print OUT "Panel: HHT\n";
print OUT "TWIST Exome In Silico Panel\n";

my @data1;

# Ta fram datum
open IN1,$HsMinfile;
while (<IN1>) {
    chomp;
    if ($_ =~ m/^#\sS/) {
        @data1=split(/\s+/, $_);
        if ($data1[4] eq "Jan") {
                print OUT "Datum: $data1[8]01$data1[5]\n";
        }
        if ($data1[4] eq "Feb") {
                print OUT "Datum: $data1[8]02$data1[5]\n";
        }
        if ($data1[4] eq "Mar") {
                print OUT "Datum: $data1[8]03$data1[5]\n";
        }
        if ($data1[4] eq "Apr") {
                print OUT "Datum: $data1[8]04$data1[5]\n";
        }
        if ($data1[4] eq "May") {
                print OUT "Datum: $data1[8]05$data1[5]\n";
        }
        if ($data1[4] eq "Jun") {
                print OUT "Datum: $data1[8]06$data1[5]\n";
        }
        if ($data1[4] eq "Jul") {
                print OUT "Datum: $data1[8]07$data1[5]\n";
        }
        if ($data1[4] eq "Aug") {
                print OUT "Datum: $data1[8]08$data1[5]\n";
        }
        if ($data1[4] eq "Sep") {
                print OUT "Datum: $data1[8]09$data1[5]\n";
        }
        if ($data1[4] eq "Okt") {
                print OUT "Datum: $data1[8]10$data1[5]\n";
        }
        if ($data1[4] eq "Nov") {
                print OUT "Datum: $data1[8]11$data1[5]\n";
        }
        if ($data1[4] eq "Dec") {
                print OUT "Datum: $data1[8]12$data1[5]\n";
        }
    }
}
close IN1;

print OUT "vcf: $name-gatk-haplotype_cg_".$iterationnumber.".vcf.gz\n";
print OUT "*********************************************\n";
print OUT "Bioinformatisk analys\n\n";

my @data2;
my @data2_percentage;

open IN2,$Bamtoolsinfile1;
while (<IN2>) {
    chomp;

    if ($_ =~ m/SN\tsequences:/) {
        @data2=split(/\s+/, $_);
        @data2_percentage=split(/\s+/, $_);
        my $total_reads=$data2[2];
        print OUT "Antal reads: $total_reads\n";
    }
    if ($_ =~ m/SN\treads\ mapped:/) {
        @data2=split(/\s+/, $_);
        my $mapped_reads=$data2[3];
        my $pct_mapped_reads=eval sprintf('%.2f',$data2[3]/$data2_percentage[2]*100);
        $pct_mapped_reads="(".$pct_mapped_reads."%)";
        print OUT "Antal mappade reads:\t$mapped_reads\t$pct_mapped_reads\n";
    }
}

my @data3;
open IN3,$HsMinfile;
while (<IN3>) {
    chomp;
    if ($_ =~ m/^s/) { next; }
    if ($_ =~ m/^#/) { next; }
    if ($_ =~ m/^B/) { next; }
    if ($_ =~ m/^$/) { next; }
    @data3=split(/\s+/, $_);
    my $andel_reads=$data3[17];
    print OUT "Andel reads på target: $andel_reads\n";
}

my @data4;
open IN4,$GATKinfile1;
while (<IN4>) {
    chomp;
    if ($_ =~ m/^s/) { next; }
    if ($_ =~ m/^T/) { next; }
    @data4=split(/\s+/, $_);
    my $total_mean=$data4[2];
    my $total_20x=eval sprintf('%.6f',$data4[7]);
    my $total_10x=eval sprintf('%.6f',$data4[6]);

    print OUT "Täckningsdjup medel (x): $total_mean\n";
    print OUT "Täckning (% ≥10x): $total_10x\n";
    print OUT "Täckning (% ≥20x): $total_20x\n\n";
}


print OUT "Gener i panel:\n";
print OUT "Gen\tMedel(x)\tTäckning≥10x(%)\tTäckning≥20x(%)\n";

my %datahash1;
my @data6;
open IN5,$limitfile;
while (<IN5>) {
    chomp;
        if ($_ =~ m/^#/) { next; }
        @data6=split(/\t/, $_);
        $datahash1{$data6[0]}=$data6[1];
}

my %datahash2;
my @data5;
my $line1;
open IN6,$GATKinfile2;
while (<IN6>) {
    chomp;
        if ($_ =~ m/^Gene/) { next; }
        @data5=split(/\s+/, $_);
    $line1 = join ("\t", @data5[0,4,8,9]);
        $datahash2{$data5[0]}{'coverage'} = $data5[9];
        $datahash2{$data5[0]}{'info'} = $line1;
}
foreach ( sort keys %datahash2) {
    if ( exists $datahash1{$_}) {
            if ($datahash2{$_}{'coverage'} < $datahash1{$_}) {
                print OUT "$datahash2{$_}{'info'} *\n";
            } else {
             print OUT "$datahash2{$_}{'info'}\n";
            }
    } else {
        print OUT "$_\t$datahash2{$_}\t Genen finns inte med i valideringslistan.\n";
    }
}


print OUT "\n";
print OUT "Regioner som inte täcks med 10x:\n";
print OUT "Kromosom\tStart\tStop\tStorlek\tTäckningsdjup(x)\tGen_intervall\n";

my @data7;
my $line2;
open IN7,$ExCIDinfile;
while (<IN7>) {
    chomp;
        if ($_ =~ m/^#/) { next; }
        @data7=split(/\s+/, $_);
        $line2 = join ("\t", @data7[0,1,2,3,4,12]);
        print OUT "$line2\n";
}
print OUT "\n";
print OUT "* Avviker > 2 standardavvikelser från valideringen.\n";
print OUT "*********************************************";

close IN2;
close IN3;
close IN4;
close IN5;
close IN6;
close IN7;
close OUT;
