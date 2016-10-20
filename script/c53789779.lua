--Quei Lian, The Dimension Traveler Taoist Dragon
function c53789779.initial_effect(c)
	--fus limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c53789779.interactlimit)
	c:RegisterEffect(e1)
	--sync limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(c53789779.interactlimit)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c53789779.interactlimit)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--summon,flip
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(c53789779.retreg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)
	--banish
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(53789779,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCondition(c53789779.spiritcon)
	e7:SetTarget(c53789779.spirittg)
	e7:SetOperation(c53789779.spiritop)
	c:RegisterEffect(e7)
end
function c53789779.interactlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c53789779.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(53789779,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c53789779.retcon)
	e1:SetTarget(c53789779.rettg)
	e1:SetOperation(c53789779.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c53789779.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c53789779.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c53789779.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c53789779.spiritcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c53789779.spirittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c53789779.spiritop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,2)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end