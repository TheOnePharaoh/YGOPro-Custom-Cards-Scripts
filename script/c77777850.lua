--Mystic Fauna Winger
function c77777850.initial_effect(c)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777850,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,77777850)
	e1:SetCondition(c77777850.spcon)
	c:RegisterEffect(e1)
  --special summon
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(c77777850.spop)
	c:RegisterEffect(e2)
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c77777850.matcon)
	e3:SetOperation(c77777850.matop)
	c:RegisterEffect(e3)
end

function c77777850.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c77777850.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=c:GetReasonCard()
  if rc:IsSetCard(0x40a) then
  	local mt=rc:GetMaterial()
    mt=mt:Filter(Card.IsAbleToDeck,c)
    Duel.SendtoDeck(mt,nil,2,REASON_EFFECT)
  end
end


function c77777850.filter(c)
	return c:IsSetCard(0x40a)and c:IsFaceup()
end

function c77777850.spcon(e,c)
	if c==nil then return true end
  local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(c77777850.filter,tp,LOCATION_MZONE,0,1,nil)
end

function c77777850.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+0x47e0000)
		e5:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e5,true)
  end
