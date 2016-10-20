--Lisa, Magi of the Sword Summoner
function c20912298.initial_effect(c)
	--sum limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c20912298.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--reveal
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20912298,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c20912298.target)
	e4:SetOperation(c20912298.operation)
	c:RegisterEffect(e4)
	--Convert race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c20912298.eqcon)
	e5:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e5)
end
function c20912298.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP)
end
function c20912298.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c20912298.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c20912298.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c20912298.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xd0a2) and tc:IsType(TYPE_EQUIP) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c20912298.propfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER) and not c:IsCode(20912298)
end
function c20912298.eqcon(e)
	return Duel.IsExistingMatchingCard(c20912298.propfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end