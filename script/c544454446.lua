--Malefic Dark Magician
function c544454446.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454446.spcon)
	e1:SetOperation(c544454446.spop)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c544454446.excon)
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
	e4:SetTarget(c544454446.sumlimit)
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
	e7:SetCondition(c544454446.descon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c544454446.destarget)
	c:RegisterEffect(e8)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c544454446.antarget)
	c:RegisterEffect(e8)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(544454446,0))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c544454446.descost)
	e9:SetTarget(c544454446.destg)
	e9:SetOperation(c544454446.desop)
	c:RegisterEffect(e9)
end
c544454446.dark_magician_list=true
function c544454446.sumlimit(e,c)
	return c:IsSetCard(0x23)
end
function c544454446.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c544454446.excon(e)
	return Duel.IsExistingMatchingCard(c544454446.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454446.spfilter(c)
	return c:IsCode(46986414) and c:IsAbleToRemoveAsCost()
end
function c544454446.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454446.spfilter,c:GetControler(),LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c544454446.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454446.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c544454446.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c544454446.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454446.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c544454446.antarget(e,c)
	return c~=e:GetHandler()
end
function c544454446.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c544454446.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454446.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c544454446.cfilter,1,1,REASON_COST)
end
function c544454446.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c544454446.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
