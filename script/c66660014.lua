--Circle of the Dragonsbane - Eternal Ceremony
function c66660014.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(66660014,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,66660014)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c66660014.sptg)
	e2:SetOperation(c66660014.spop)
	c:RegisterEffect(e2)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(c66660014.chainfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetValue(c66660014.chainfilter)
	c:RegisterEffect(e6)
	--cannot disable summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISABLE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	c:RegisterEffect(e7)
		local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c66660014.sucop)
	e8:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAIN_END)
	e9:SetOperation(c66660014.cedop)
	e9:SetRange(LOCATION_FZONE)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
		--to hand
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_DESTROYED)
	e10:SetCountLimit(1,66660014)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetCondition(c66660014.thcon2)
	e10:SetTarget(c66660014.thtg2)
	e10:SetOperation(c66660014.thop2)
	c:RegisterEffect(e10)
end
function c66660014.etarget(e,c)
	return c:GetRace()==RACE_DRAGON
end
function c66660014.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:GetRace()==RACE_DRAGON
end
function c66660014.chainlm(e,rp,tp)
	return tp==rp
end
function c66660014.sucfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL) and bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c66660014.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c66660014.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c66660014.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c66660014.chainlm)
	end
end
function c66660014.ritual_filter(c,e,tp,m)
	local lv=c:GetLevel()
	if c:IsLocation(LOCATION_GRAVE) then lv=c:GetOriginalLevel() end
	if not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c66660014.mfilter(c)
	return c:GetOriginalLevel()>0 and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToGraveAsCost()
end
function c66660014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(c66660014.mfilter,tp,LOCATION_HAND,0,nil)
		mg:Merge(sg)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			return Duel.IsExistingMatchingCard(c66660014.ritual_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg) end
		return Duel.IsExistingMatchingCard(c66660014.ritual_filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c66660014.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		tg=Duel.SelectMatchingCard(tp,c66660014.ritual_filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	else tg=Duel.SelectMatchingCard(tp,c66660014.ritual_filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg) end
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		if tc.mat_filter then
		   mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c66660014.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5
end
function c66660014.thfilter2(c)
	return c:IsSetCard(0x4c2) and c:IsAbleToHand()
end
function c66660014.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66660014.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66660014.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66660014.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end