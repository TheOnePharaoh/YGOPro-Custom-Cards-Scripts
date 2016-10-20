--Abyssal Corruption
--lua script by SGJin
function c12310747.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c12310747.cost)
	e1:SetTarget(c12310747.target)
	e1:SetOperation(c12310747.activate)
	c:RegisterEffect(e1)
end
function c12310747.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c12310747.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c12310747.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,lv,c:GetOriginalRace(),e,tp)
end
function c12310747.spfilter(c,lv,rc,e,tp)
	return c:GetLevel()>lv and c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12310747.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c12310747.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c12310747.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c12310747.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tg=Duel.GetFirstTarget()
	if not tg:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12310747.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tg:GetLevel(),tg:GetRace(),e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(ATTRIBUTE_DARK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		if tc:IsType(TYPE_NORMAL) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e4:SetValue(c12310747.efilter)
			e4:SetOwnerPlayer(tp)
			g:GetFirst():RegisterEffect(e4,true)
		end
	end
	local lvDiff=tc:GetLevel()-tg:GetPreviousLevelOnField()
	Duel.Damage(tp,lvDiff*800,REASON_EFFECT)
end
function c12310747.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end