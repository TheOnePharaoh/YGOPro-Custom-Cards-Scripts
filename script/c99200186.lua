--Dark Android Boltman
function c99200186.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99200186.efilter)
	c:RegisterEffect(e1)
 	 --negate & spsummon
 	 local e2=Effect.CreateEffect(c)
 	 e2:SetDescription(aux.Stringid(99200186,0))
 	 e2:SetType(EFFECT_TYPE_QUICK_O)
 	 e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
 	 e2:SetCode(EVENT_CHAINING)
	 e2:SetRange(LOCATION_HAND)
 	 e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	 e2:SetCountLimit(1,99200186)
 	 e2:SetCondition(c99200186.negcon)
 	 e2:SetTarget(c99200186.negtg)
 	 e2:SetOperation(c99200186.negop)
 	 c:RegisterEffect(e2)
end
function c99200186.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200186.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return ep~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c99200186.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99200186.negfil(c,e,tp)
  return c:IsCode(5717744) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99200186.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
