--Dark Android Cyber End Dragon
function c99200178.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99200178.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99200178.sprcon)
	e2:SetOperation(c99200178.sprop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200178.immfilter)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--double
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c99200178.damcon)
	e5:SetOperation(c99200178.damop)
	c:RegisterEffect(e5)
	--attack three times
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e7:SetCondition(c99200178.dircon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetCondition(c99200178.atkcon)
	c:RegisterEffect(e8)
end
function c99200178.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99200178.spfilter1(c,tp)
	return c:IsCode(99200151) and Duel.IsExistingMatchingCard(c99200178.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c)
end
function c99200178.spfilter2(c)
	return c:IsRace(RACE_MACHINE)
end
function c99200178.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c99200178.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c99200178.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200178,0))
	local g1=Duel.SelectMatchingCard(tp,c99200178.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200178,1))
	local g2=Duel.SelectMatchingCard(tp,c99200178.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c99200178.immfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99200178.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsDefensePos()
end
function c99200178.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c99200178.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c99200178.atkcon(e)
	return e:GetHandler():IsDirectAttacked()
end
