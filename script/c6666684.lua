--Hypnos, Shaderune of Dreams
function c6666684.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c6666684.synfilter2,aux.NonTuner(c6666684.synfilter),1)
	c:EnableReviveLimit()
	--Position+Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666684,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCost(c6666684.poscost)
	e1:SetTarget(c6666684.postg)
	e1:SetOperation(c6666684.posop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666684,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c6666684.spcon)
	e2:SetTarget(c6666684.sptg2)
	e2:SetOperation(c6666684.spop2)
	c:RegisterEffect(e2)
end
function c6666684.synfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c6666684.synfilter(c)
	return c:IsSetCard(0x900)
end
function c6666684.cfilter(c)
    return c:IsAbleToRemoveAsCost()
end
function c6666684.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c6666684.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c6666684.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c6666684.filter(c)
    return c:IsAttackPos()
end
function c6666684.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c6666684.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c6666684.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c6666684.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c6666684.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)>0 and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end
function c6666684.filter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c6666684.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c6666684.filter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c6666684.xfilter(c,e,tp,rk)
	return c:GetRank()==8 and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0x900)
end
function c6666684.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c6666684.xfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6666684.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6666684.xfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end