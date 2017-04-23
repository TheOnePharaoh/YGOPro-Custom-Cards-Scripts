--Legendary Vocaloid Sonika
function c41006367.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c41006367.spcon)
	e2:SetOperation(c41006367.spop)
	c:RegisterEffect(e2)
	--negate	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c41006367.disable)
	c:RegisterEffect(e3)
	--option1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c41006367.optcon1)
	e4:SetValue(c41006367.immval)
	c:RegisterEffect(e4)
	--option2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c41006367.optcon2)
	e5:SetTarget(c41006367.indtg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--option3
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(41006367,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c41006367.optcon3)
	e7:SetTarget(c41006367.destg)
	e7:SetOperation(c41006367.desop)
	c:RegisterEffect(e7)
end
function c41006367.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,3,nil,0x0dac402)
end
function c41006367.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,3,3,nil,0x0dac402)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c41006367.disable(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c41006367.confilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c41006367.optcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c41006367.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c41006367.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c41006367.optcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c41006367.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
function c41006367.indtg(e,c)
	return c:IsSetCard(0x0dac405) and c~=e:GetHandler()
end
function c41006367.optcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c41006367.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,4,nil)
end
function c41006367.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c41006367.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end
