--SAO - Phantom Bullet
function c99990580.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DELAYED_QUICKEFFECT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c99990580.target)
	e1:SetOperation(c99990580.activate)
	c:RegisterEffect(e1)
end
function c99990580.filter1(c,e,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
	and c:IsSetCard(9999) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0 and c:IsCanBeEffectTarget(e) and c:GetReasonPlayer()~=tp and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99990580.filter2(c,lv,e,tp)
	return c:IsSetCard(9999) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990580.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c99990580.filter1(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c99990580.filter1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c99990580.filter1,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,nil,1-tp,0)
end
function c99990580.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99990580.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
