--Malefic Shooting Quasar Dragon
function c544454448.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454448.spcon)
	e1:SetOperation(c544454448.spop)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c544454448.excon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetTarget(c544454448.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c544454448.descon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c544454448.destarget)
	c:RegisterEffect(e8)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c544454448.antarget)
	c:RegisterEffect(e8)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCountLimit(1)
	e10:SetValue(c544454448.valcon)
	c:RegisterEffect(e10)
	--special summon malefic
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(4779091,2))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetTarget(c544454448.msptg)
	e11:SetOperation(c544454448.mspop)
	c:RegisterEffect(e11)
end
function c544454448.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c544454448.sumlimit(e,c)
	return c:IsSetCard(0x23)
end
function c544454448.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c544454448.excon(e)
	return Duel.IsExistingMatchingCard(c544454448.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454448.spfilter(c)
	return c:IsCode(35952884) and c:IsAbleToRemoveAsCost()
end
function c544454448.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454448.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
		and not Duel.IsExistingMatchingCard(c544454448.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454448.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c544454448.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c544454448.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454448.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c544454448.antarget(e,c)
	return c~=e:GetHandler()
end
function c544454448.fifilter(c,fc,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and fc==nil
end
function c544454448.mspfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:GetCode()~=544454448 and c:GetCode()~=37115575
end
function c544454448.msptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454448.fifilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,fc,tp) 
		or Duel.IsExistingMatchingCard(c544454448.mspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c544454448.mspop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local g1=Duel.GetMatchingGroup(c544454448.fifilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,fc,tp)
	local chk=0
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26640671,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local sc=g1:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(sc,EVENT_CHAIN_SOLVED,sc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		chk=1
	end
	local g2=Duel.GetMatchingGroup(c544454448.mspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g2:GetCount()>0 and (chk==0 or Duel.SelectYesNo(tp,aux.Stringid(440556,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(spg,0,tp,tp,true,false,POS_FACEUP)
		spg:GetFirst():CompleteProcedure()
	end
end
