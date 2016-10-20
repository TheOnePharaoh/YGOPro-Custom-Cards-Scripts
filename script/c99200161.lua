--Dark Android Catapult
function c99200161.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99200161.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99200161.sprcon)
	e2:SetOperation(c99200161.sprop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200161.immfilter)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99200161,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c99200161.dmgcon)
	e5:SetOperation(c99200161.dmgop)
	c:RegisterEffect(e5)
end
function c99200161.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99200161.spfilter1(c,tp)
	return c:IsCode(99200151) and Duel.IsExistingMatchingCard(c99200161.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c)
end
function c99200161.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200161.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c99200161.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c99200161.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200161,0))
	local g1=Duel.SelectMatchingCard(tp,c99200161.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200161,1))
	local g2=Duel.SelectMatchingCard(tp,c99200161.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c99200161.immfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99200161.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActiveType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(1)>0
end
function c99200161.dmgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
