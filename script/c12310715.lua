--Jolly Co-operation
--lua script by SGJin
function c12310715.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Co-operation Atk boost!
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c12310715.atktg)
	e2:SetValue(c12310715.atkval)
	c:RegisterEffect(e2)
	--Summon a friendly phantom
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310715,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c12310715.sumcon)
	e3:SetTarget(c12310715.sumtg)
	e3:SetOperation(c12310715.sumop)
	c:RegisterEffect(e3)
end
function c12310715.filter(c)
	return (c:IsRace(RACE_WARRIOR) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)))
		or (c:IsRace(RACE_SPELLCASTER) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)))
end
function c12310715.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,12310712)
end
function c12310715.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310715.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c12310715.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12310715.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function c12310715.atktg(e,c)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER)
end
function c12310715.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER)
end
function c12310715.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12310715.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
