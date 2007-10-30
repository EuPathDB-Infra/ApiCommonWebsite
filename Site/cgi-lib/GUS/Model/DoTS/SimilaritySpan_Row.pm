package GUS::Model::DoTS::SimilaritySpan_Row;

# THIS CLASS HAS BEEN AUTOMATICALLY GENERATED BY THE GUS::ObjRelP::Generator 
# PACKAGE.
#
# DO NOT EDIT!!

use strict;
use GUS::Model::GusRow;

use vars qw (@ISA);
@ISA = qw (GUS::Model::GusRow);

sub setDefaultParams {
  my ($self) = @_;
  $self->setVersionable(1);
  $self->setUpdateable(1);
}

sub setSimilaritySpanId {
  my($self,$value) = @_;
  $self->set("similarity_span_id",$value);
}

sub getSimilaritySpanId {
    my($self) = @_;
  return $self->get("similarity_span_id");
}

sub setSimilarityId {
  my($self,$value) = @_;
  $self->set("similarity_id",$value);
}

sub getSimilarityId {
    my($self) = @_;
  return $self->get("similarity_id");
}

sub setMatchLength {
  my($self,$value) = @_;
  $self->set("match_length",$value);
}

sub getMatchLength {
    my($self) = @_;
  return $self->get("match_length");
}

sub setNumberIdentical {
  my($self,$value) = @_;
  $self->set("number_identical",$value);
}

sub getNumberIdentical {
    my($self) = @_;
  return $self->get("number_identical");
}

sub setNumberPositive {
  my($self,$value) = @_;
  $self->set("number_positive",$value);
}

sub getNumberPositive {
    my($self) = @_;
  return $self->get("number_positive");
}

sub setScore {
  my($self,$value) = @_;
  $self->set("score",$value);
}

sub getScore {
    my($self) = @_;
  return $self->get("score");
}

sub setBitScore {
  my($self,$value) = @_;
  $self->set("bit_score",$value);
}

sub getBitScore {
    my($self) = @_;
  return $self->get("bit_score");
}

sub setPvalueMant {
  my($self,$value) = @_;
  $self->set("pvalue_mant",$value);
}

sub getPvalueMant {
    my($self) = @_;
  return $self->get("pvalue_mant");
}

sub setPvalueExp {
  my($self,$value) = @_;
  $self->set("pvalue_exp",$value);
}

sub getPvalueExp {
    my($self) = @_;
  return $self->get("pvalue_exp");
}

sub setSubjectStart {
  my($self,$value) = @_;
  $self->set("subject_start",$value);
}

sub getSubjectStart {
    my($self) = @_;
  return $self->get("subject_start");
}

sub setSubjectEnd {
  my($self,$value) = @_;
  $self->set("subject_end",$value);
}

sub getSubjectEnd {
    my($self) = @_;
  return $self->get("subject_end");
}

sub setQueryStart {
  my($self,$value) = @_;
  $self->set("query_start",$value);
}

sub getQueryStart {
    my($self) = @_;
  return $self->get("query_start");
}

sub setQueryEnd {
  my($self,$value) = @_;
  $self->set("query_end",$value);
}

sub getQueryEnd {
    my($self) = @_;
  return $self->get("query_end");
}

sub setIsReversed {
  my($self,$value) = @_;
  $self->set("is_reversed",$value);
}

sub getIsReversed {
    my($self) = @_;
  return $self->get("is_reversed");
}

sub setReadingFrame {
  my($self,$value) = @_;
  $self->set("reading_frame",$value);
}

sub getReadingFrame {
    my($self) = @_;
  return $self->get("reading_frame");
}

sub setModificationDate {
  my($self,$value) = @_;
  $self->set("modification_date",$value);
}

sub getModificationDate {
    my($self) = @_;
  return $self->get("modification_date");
}

sub setUserRead {
  my($self,$value) = @_;
  $self->set("user_read",$value);
}

sub getUserRead {
    my($self) = @_;
  return $self->get("user_read");
}

sub setUserWrite {
  my($self,$value) = @_;
  $self->set("user_write",$value);
}

sub getUserWrite {
    my($self) = @_;
  return $self->get("user_write");
}

sub setGroupRead {
  my($self,$value) = @_;
  $self->set("group_read",$value);
}

sub getGroupRead {
    my($self) = @_;
  return $self->get("group_read");
}

sub setGroupWrite {
  my($self,$value) = @_;
  $self->set("group_write",$value);
}

sub getGroupWrite {
    my($self) = @_;
  return $self->get("group_write");
}

sub setOtherRead {
  my($self,$value) = @_;
  $self->set("other_read",$value);
}

sub getOtherRead {
    my($self) = @_;
  return $self->get("other_read");
}

sub setOtherWrite {
  my($self,$value) = @_;
  $self->set("other_write",$value);
}

sub getOtherWrite {
    my($self) = @_;
  return $self->get("other_write");
}

sub setRowUserId {
  my($self,$value) = @_;
  $self->set("row_user_id",$value);
}

sub getRowUserId {
    my($self) = @_;
  return $self->get("row_user_id");
}

sub setRowGroupId {
  my($self,$value) = @_;
  $self->set("row_group_id",$value);
}

sub getRowGroupId {
    my($self) = @_;
  return $self->get("row_group_id");
}

sub setRowProjectId {
  my($self,$value) = @_;
  $self->set("row_project_id",$value);
}

sub getRowProjectId {
    my($self) = @_;
  return $self->get("row_project_id");
}

sub setRowAlgInvocationId {
  my($self,$value) = @_;
  $self->set("row_alg_invocation_id",$value);
}

sub getRowAlgInvocationId {
    my($self) = @_;
  return $self->get("row_alg_invocation_id");
}

1;
