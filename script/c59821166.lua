--Aetherian's Fireball
function c59821166.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c59821166.target)
	e1:SetOperation(c59821166.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821166,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821166)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c59821166.spcost)
	e2:SetTarget(c59821166.sptarget)
	e2:SetOperation(c59821166.spoperation)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c59821166.handcon)
	c:RegisterEffect(e3)
end
function c59821166.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c59821166.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821166.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dmg=Duel.GetMatchingGroupCount(c59821166.filter,tp,LOCATION_MZONE,0,nil)*200
	if chk==0 then return dmg>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dmg)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dmg)
end
function c59821166.operation(e,tp,eg,ep,ev,re,r,rp)
	local dmg=Duel.GetMatchingGroupCount(c59821166.filter,tp,LOCATION_MZONE,0,nil)*200
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,dmg,REASON_EFFECT)
end
function c59821166.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821166.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821166.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) and c59821166.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c59821166.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c59821166.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c59821166.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end