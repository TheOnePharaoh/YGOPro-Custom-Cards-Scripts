--MoonBurst placeholder
function c4242577.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c4242577.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),false)

	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c4242577.spcon)
	e1:SetOperation(c4242577.spop)
	c:RegisterEffect(e1)
		--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82482194,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4242577.atcon)
	e1:SetOperation(c4242577.atop)
	c:RegisterEffect(e1)

end
c4242577.pendulum_level=6
function c4242577.ffilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WIND)
end

function c4242577.spfilter1(c,tp,fc)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c4242577.spfilter2,1,c,fc)
end
function c4242577.spfilter2(c,fc)
	return c:IsRace(RACE_WINDBEAST) and c:IsCanBeFusionMaterial(fc)
end
function c4242577.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c4242577.spfilter1,1,nil,tp,c) and c:IsFacedown()  --this
end
function c4242577.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c4242577.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c4242577.spfilter2,2,2,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end

function c4242577.filter(c,rc)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetReasonCard()==rc
end
function c4242577.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4242577.filter,1,nil,e:GetHandler())
end
function c4242577.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
