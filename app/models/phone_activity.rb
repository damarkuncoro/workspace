class PhoneActivity < ApplicationRecord
  belongs_to :phone

  validates :activity_type, presence: true, inclusion: {
    in: %w[call_made call_received sms_sent sms_received voicemail]
  }
  validates :activity_at, presence: true
  validates :contact_number, presence: true
  validates :call_direction, inclusion: { in: %w[inbound outbound], allow_nil: true }
  validates :call_status, inclusion: { in: %w[answered missed voicemail], allow_nil: true }

  # Scopes
  scope :recent, -> { order(activity_at: :desc) }
  scope :by_type, ->(type) { where(activity_type: type) }
  scope :calls, -> { where(activity_type: %w[call_made call_received voicemail]) }
  scope :messages, -> { where(activity_type: %w[sms_sent sms_received]) }
  scope :inbound, -> { where(call_direction: 'inbound') }
  scope :outbound, -> { where(call_direction: 'outbound') }
  scope :answered, -> { where(call_status: 'answered') }
  scope :missed, -> { where(call_status: 'missed') }

  # Methods
  def activity_type_label
    case activity_type
    when 'call_made' then 'Outgoing Call'
    when 'call_received' then 'Incoming Call'
    when 'sms_sent' then 'SMS Sent'
    when 'sms_received' then 'SMS Received'
    when 'voicemail' then 'Voicemail'
    else activity_type.titleize
    end
  end

  def formatted_duration
    return nil unless duration_seconds.present?

    hours = duration_seconds / 3600
    minutes = (duration_seconds % 3600) / 60
    seconds = duration_seconds % 60

    if hours > 0
      format("%02d:%02d:%02d", hours, minutes, seconds)
    else
      format("%02d:%02d", minutes, seconds)
    end
  end

  def is_call?
    %w[call_made call_received voicemail].include?(activity_type)
  end

  def is_message?
    %w[sms_sent sms_received].include?(activity_type)
  end

  def is_inbound?
    call_direction == 'inbound'
  end

  def is_outbound?
    call_direction == 'outbound'
  end

  def was_answered?
    call_status == 'answered'
  end

  def was_missed?
    call_status == 'missed'
  end

  def has_voicemail?
    call_status == 'voicemail'
  end
end