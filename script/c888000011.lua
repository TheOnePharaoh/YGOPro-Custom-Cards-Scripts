--Evil HERO Shock Conductor
function c888000011.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,20721928,58554959,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000011.splimit)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000011,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c888000011.descost)
	e3:SetTarget(c888000011.destg)
	e3:SetOperation(c888000011.desop)
	c:RegisterEffect(e3)
end
c888000011.dark_calling=true
function c888000011.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000011.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c888000011.filter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and (c:GetDefense()>atk or c:GetAttack()>atk or c:GetEffectCount(EFFECT_INDESTRUCTABLE_BATTLE)==1)
end
function c888000011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c888000011.filter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c888000011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c888000011.filter,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c888000011.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,nil,code)
		if Duel.Destroy(tc,REASON_EFFECT)>0 and g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
