--Starstream Dragon
function c103950025.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c103950025.spcon)
	e1:SetTarget(c103950025.sptg)
	e1:SetOperation(c103950025.spop)
	c:RegisterEffect(e1)
	--Level Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950025,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c103950025.lvltg)
	e2:SetOperation(c103950025.lvlop)
	c:RegisterEffect(e2)
end
function c103950025.spfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and not c:IsPreviousLocation(LOCATION_HAND)
end
function c103950025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103950025.spfilter,1,nil,tp)
end
function c103950025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c103950025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c103950025.lvlfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetLevel() > 4
end
function c103950025.lvltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c103950025.lvlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103950025,2))
	Duel.SelectTarget(tp,c103950025.lvlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c103950025.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		local count = 3
		local prevLevel = tc:GetLevel()
		if prevLevel < 7 then
			count = prevLevel - 4
		end
		if count <= 0 then
			return
		end
		local t={}
		local i=1
		for i=1,count do 
			t[i]=i
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103950025,3))
		local choice = Duel.AnnounceNumber(tp,table.unpack(t))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(choice * -1)
		tc:RegisterEffect(e1)
		if tc:GetLevel()==prevLevel-choice then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(choice * 300)
			c:RegisterEffect(e2)
		end
	end
end
