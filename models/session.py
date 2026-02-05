"""
Session and Intelligence Models
"""

from pydantic import BaseModel, Field
from typing import List, Optional, Dict
from datetime import datetime


class MessageContent(BaseModel):
    """Message content structure"""
    sender: str
    text: str
    timestamp: str


class MessageMetadata(BaseModel):
    """Metadata for the message"""
    channel: Optional[str] = "SMS"
    language: Optional[str] = "English"
    locale: Optional[str] = "IN"


class ConversationMessage(BaseModel):
    """Single message in conversation history"""
    sender: str
    text: str
    timestamp: str


class MessageRequest(BaseModel):
    """Request model for honeypot endpoint - Hackathon Compliant"""
    sessionId: str
    message: MessageContent
    conversationHistory: List[ConversationMessage] = []
    metadata: Optional[MessageMetadata] = None


class EngagementMetrics(BaseModel):
    """Engagement metrics"""
    engagementDurationSeconds: int
    totalMessagesExchanged: int


class ExtractedIntelligence(BaseModel):
    """Extracted intelligence structure"""
    bankAccounts: List[str] = []
    upiIds: List[str] = []
    phishingLinks: List[str] = []
    phoneNumbers: List[str] = []
    suspiciousKeywords: List[str] = []


class MessageResponse(BaseModel):
    """Response model for honeypot endpoint - Hackathon Compliant"""
    status: str
    reply: str
    scamDetected: bool = False
    engagementMetrics: Optional[EngagementMetrics] = None
    extractedIntelligence: Optional[ExtractedIntelligence] = None
    agentNotes: Optional[str] = None


class IntelligenceData(BaseModel):
    """Intelligence extracted from conversation"""
    upi_ids: List[str] = []
    phone_numbers: List[str] = []
    urls: List[str] = []
    bank_accounts: List[str] = []
    ifsc_codes: List[str] = []
    suspicious_keywords: List[str] = []


class SessionData(BaseModel):
    """Complete session data"""
    session_id: str
    persona_name: str
    scam_confirmed: bool = False
    scam_confidence: float = 0.0
    scam_types: List[str] = []
    message_count: int = 0
    intelligence_extracted: IntelligenceData = IntelligenceData()
    phase: str = "initiated"
    callback_sent: bool = False
    created_at: datetime = datetime.now()
    last_active: datetime = datetime.now()


class DetailedMessageResponse(BaseModel):
    """Detailed response for testing/debugging"""
    sessionId: str
    reply: str
    scamDetected: bool
    scamIntents: List[str]
    confidence: float
    shouldContinue: bool
    extractedIntelligence: Dict
    conversationPhase: str
    messageCount: int


class CallbackPayload(BaseModel):
    """Payload sent to GUVI callback endpoint - Hackathon Compliant"""
    sessionId: str
    scamDetected: bool
    totalMessagesExchanged: int
    extractedIntelligence: ExtractedIntelligence
    agentNotes: str
