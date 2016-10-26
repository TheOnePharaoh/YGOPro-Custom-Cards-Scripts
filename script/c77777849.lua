--Mystic Fauna Terrier
function c77777849.initial_effect(c)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77777849.matcon)
	e2:SetOperation(c77777849.matop)
	c:RegisterEffect(e2)
  --become material to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_MATERIAL)
  e3:SetDescription(aux.Stringid(77777849,1))
  e3:SetCountLimit(1,77777849)
	e3:SetCondition(c77777849.matcon2)
	e3:SetOperation(c77777849.matop2)
	c:RegisterEffect(e3)
  --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetDescription(aux.Stringid(77777849,0))
	e5:SetCondition(c77777849.spcon1)
	e5:SetTarget(c77777849.sptg1)
	e5:SetOperation(c77777849.spop1)
	c:RegisterEffect(e5)
end

function c77777849.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c77777849.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=c:GetReasonCard()
  if rc:IsSetCard(0x40a) then
  	local mt=rc:GetMaterial()
    mt=mt:Filter(Card.IsAbleToDeck,c)
    Duel.SendtoDeck(mt,nil,2,REASON_EFFECT)
  end
end

function c77777849.matcon2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsLevelBelow(3)
end
function c77777849.matop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local rc=c:GetReasonCard()
  if rc:IsLevelBelow(3) then
  	Duel.SendtoHand(c,nil,REASON_EFFECT)
 end
end

function c77777849.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40a) and c:GetSummonPlayer()==tp
end
function c77777849.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777849.cfilter,1,nil,tp)
end
function c77777849.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777849.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end