#!/usr/bin/perl
use strict;
use warnings;
use Pod::Usage;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);

my @customerCareLogs = ('D',
			'thread_id',
			'tcap_tid:hex',
			'pdu_type',
			'opcode_qualifier',
			'direction',
			'start_ts_msecs',
			'final_ts_msecs',
			'msg_id',
			'src_operator_id',
			'dst_operator_id',
			'src_ton',
			'src_npi',
			'src_addr',
			'dst_ton',
			'dst_npi',
			'dst_addr',
			'dst_imsi',
			'src_esme',
			'dst_esme',
			'src_sccp_addr_ind',
			'src_sccp_pc',
			'src_sccp_pc_str',
			'src_sccp_ssn',
			'src_sccp_tt',
			'src_sccp_np',
			'src_sccp_es',
			'src_sccp_nai',
			'src_sccp_addr',
			'dst_sccp_addr_ind',
			'dst_sccp_pc',
			'dst_sccp_pc_str',
			'dst_sccp_ssn',
			'dst_sccp_tt',
			'dst_sccp_np',
			'dst_sccp_es',
			'dst_sccp_nai',
			'dst_sccp_addr',
			'gsm_phase',
			'error_code:hex',
			'blocking_reason',
			'iw_identity',
			'gw_identity',
			'src_hub',
			'dst_hub',
			'status',
			'vmsc_addr',
			'src_op_name',
			'dst_op_name',
			'enum_nr_attempts',
			'dst_mnp_dip_type',
			'dst_mnp_enum_value',
			'data_coding',
			'esm_class',
			'smsc_map_addr');

my $options = {
    'man'       => 0,
    'help'      => 0,
    'logfile'   => undef,
    'src_esme'  => undef,
    'dst_esme'  => undef,
    'thread_id' => undef,
    'src_addr'  => undef,
    'dst_addr'  => undef,
    'pdu_type'  => undef,
    'esm_class' => undef,
};

GetOptions(
    'file|f:s'      => \$$options{'logfile'},
    'src_esme|s:s'  => \$$options{'src_esme'},
    'dst_esme|d:s'  => \$$options{'dst_esme'},
    'thread_id|i:s' => \$$options{'thread_id'},
    'src_addr|t:s'  => \$$options{'src_addr'},
    'dst_addr|r:s'  => \$$options{'dst_addr'},
    'pdu_type|p:s'  => \$$options{'pdu_type'},
    'esm_class|c:s' => \$$options{'esm_class'},
    'help|h'        => \$$options{'help'},
    'man|m'         => \$$options{'man'},
    ) or pod2usage(2);

pod2usage(1) if $$options{'help'};
pod2usage(-exitval => 0, -verbose => 2) if $$options{'man'};

die "\nOption -file or -f not specified.\n\n"
    if (!defined $$options{'logfile'} || $$options{'logfile'} eq '');

die "\nUsage: $0 [options] [file ...]\n\n" unless @ARGV == 0;

open(my $fh, '<', $$options{'logfile'})
    or die "Could not open file '$$options{'logfile'}' $!";

my @content = <$fh>;
chomp @content;

my $HoHRef = {};
my $lineNumber = 1;

foreach my $line (@content) {
    my $hashRef = {};
    next if $line =~ /^\s*$/; # If empty or white space next line
    my @values = split(',', $line); # Split all elements in line into an array
    s{^\s+|\s+$}{}g foreach @values; # Remove white space both sides
    @$hashRef{@customerCareLogs} = @values; # Assign all elements to hash values

    if ((defined $$options{'src_esme'}) &&
	($options->{'src_esme'} eq $hashRef->{'src_esme'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'dst_esme'}) &&
	   ($options->{'dst_esme'} eq $hashRef->{'dst_esme'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'thread_id'}) &&
	   ($options->{'thread_id'} eq $hashRef->{'thread_id'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'src_addr'}) &&
	   ($options->{'src_addr'} eq $hashRef->{'src_addr'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'dst_addr'}) &&
	   ($options->{'dst_addr'} eq $hashRef->{'dst_addr'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'pdu_type'}) &&
	   ($options->{'pdu_type'} eq $hashRef->{'pdu_type'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    elsif ((defined $$options{'esm_class'}) &&
	   ($options->{'esm_class'} eq $hashRef->{'esm_class'})) {
	$HoHRef->{'Line number: ' . $lineNumber++} = $hashRef;
    }
    else { next; }
}

close $fh # wait for sort to finish
    or die "Error closing '$$options{'logfile'}' $!";

print Dumper $HoHRef;

__END__

=head1 NAME

sample - Using Getopt::Long and Pod::Usage

=head1 SYNOPSIS

sample [options] [file ...]

Options:
    -help or -h
    -man or -m
    -file or -f
    -src_esme or -s
    -dst_esme or -d
    -thread_id or -i
    -src_addr or -t
    -dst_addr or -r
    -pdu_type or -p
    -esm_class or -c

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=item B<-file>

file Something

=item B<-esme>

Esme to match in CDR

=item B<-src_esme>

Source something

=item B<-dst_esme>

Destination esme

=item B<-dst_esme>

Destination esme

=item B<-thread_id>

Thread id

=item B<-src_addr>

Source addr

=item B<-dst_addr>

Destination addr

=item B<-pdu_type>

Pdu type

=item B<-esm_class>

Esme class

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something
    useful with the contents thereof.

=cut
