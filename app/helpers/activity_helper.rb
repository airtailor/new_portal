module ActivityHelper
  def create_activity(type, order_id, additional_text)
    Activity.create(
      order_id: order_id,
      activity_subject_type: self.class.name,
      activity_subject_id: self.id,
      type: type,
      additional_text: additional_text
  end
end
