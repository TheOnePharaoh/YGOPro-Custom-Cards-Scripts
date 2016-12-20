--Agni, Combustion Witch
function c66666661.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72181263,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c66666661.spcon)
	e2:SetTarget(c66666661.sptg)
	e2:SetOperation(c66666661.spop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66666661.splimit)
	c:RegisterEffect(e3)
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666655,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c66666661.tnrtarget)
	e4:SetOperation(c66666661.tnrop)
	c:RegisterEffect(e4)



end

function c66666661.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c66666661.tnrfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x29b) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c66666661.tnrtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66666661.tnrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666661.tnrfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666661.tnrfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666661.tnrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c66666661.tnrfilter(tc) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(66666661,2))then
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
				local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,sg:GetFirst(),nil)
				end
			end
		end
	end
end

function c66666661.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c66666661.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66666661.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c66666661.splimit2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(TYPE_TUNER)
		e:GetHandler():RegisterEffect(e2)
	end
end

function c66666661.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x29b)
end
