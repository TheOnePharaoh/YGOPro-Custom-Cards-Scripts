--レッドアイズ・ブラックメタルドラゴン
function c512000090.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCondition(c512000090.spcon)
	e2:SetOperation(c512000090.spop)
	c:RegisterEffect(e2)
end
function c512000090.spfilter(c)
	return c:IsCode(89091579) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,3492538)
end
function c512000090.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c512000090.spfilter,1,nil)
end
function c512000090.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c512000090.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
