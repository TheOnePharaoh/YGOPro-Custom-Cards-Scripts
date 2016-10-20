--Evil HERO Stormeye
function c88800014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,21844576,20721928,79979666,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88800014.splimit)
	c:RegisterEffect(e1)
	--Self Target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88800014,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c88800014.selfcost)
	e3:SetOperation(c88800014.selfop)
	c:RegisterEffect(e3)
	--set target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88800014,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c88800014.indestg)
	e2:SetOperation(c88800014.indesop)
	c:RegisterEffect(e2)
end
c88800014.dark_calling=true
function c88800014.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c88800014.selfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c88800014.selfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c88800014.valcon)
	c:RegisterEffect(e2)
end
function c88800014.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c88800014.indestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88800014.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if c==tc then
		tc:RegisterFlagEffect(88800014,RESET_EVENT+0x1fe0000,0,0)
	else
		c:SetCardTarget(tc)
	end
	if c:GetFlagEffect(88800014)==0 then
		c:RegisterFlagEffect(88800014,RESET_EVENT+0x1fe0000,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c88800014.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c88800014.indtg(e,c)
	if c==e:GetHandler() then
		return c:GetFlagEffect(83121692)~=0
	else
		return e:GetHandler():IsHasCardTarget(c)
	end
end
