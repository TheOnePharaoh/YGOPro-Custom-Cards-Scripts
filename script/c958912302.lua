--Astagraphy Algis
function c958912302.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c958912302.runcon)
	r1:SetOperation(c958912302.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--change pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(958912302,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c958912302.target)
	e1:SetOperation(c958912302.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c958912302.indtg)
	e2:SetValue(c958912302.indval)
	c:RegisterEffect(e2)
end
function c958912302.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c958912302.matfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xfef) and c:IsType(TYPE_TRAP)
end
function c958912302.runfilter1(c)
	return c958912302.matfilter1(c) and Duel.IsExistingMatchingCard(c958912302.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c958912302.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c958912302.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c958912302.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c958912302.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c958912302.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c958912302.filter(c)
	return c:IsAttackPos()
end
function c958912302.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c958912302.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c958912302.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c958912302.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c958912302.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
	end
end
function c958912302.indtg(e,c)
	return c:IsSetCard(0xfef)
end
function c958912302.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end