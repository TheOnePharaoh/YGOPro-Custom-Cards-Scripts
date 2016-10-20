--インヴェルズ・ガザス
function c87002906.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002906,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c87002906.condition)
	e1:SetTarget(c87002906.target)
	e1:SetOperation(c87002906.operation)
	c:RegisterEffect(e1)
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c87002906.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)
end
function c87002906.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,2,nil,0xe291ca) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c87002906.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and e:GetLabel()==1
end
function c87002906.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe291ca) and c:IsDestructable()
		and Duel.IsExistingTarget(Card.IsDestructable,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c87002906.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c87002906.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c87002906.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c87002906.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
