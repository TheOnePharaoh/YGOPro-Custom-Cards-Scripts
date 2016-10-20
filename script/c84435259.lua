--Vocaloid Otori Kohaku
function c84435259.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84435259,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,84435259)
	e1:SetTarget(c84435259.sptg)
	e1:SetOperation(c84435259.spop)
	c:RegisterEffect(e1)
	--level adjust
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84435259,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c84435259.retcon)
	e2:SetTarget(c84435259.rettg)
	e2:SetOperation(c84435259.retop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c84435259.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Group.CreateGroup()
		for i=0,4 do
			local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
			if tc and tc:IsFaceup() and tc:IsSetCard(0x0dac404) and tc:IsType(TYPE_XYZ) then
				g:Merge(tc:GetOverlayGroup())
			end
		end
		if g:GetCount()==0 then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84435259.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsSetCard(0x0dac404) and tc:IsType(TYPE_XYZ) then
			g:Merge(tc:GetOverlayGroup())
		end
	end
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP_ATTACK)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,200,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c84435259.retcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c84435259.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,9 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84435259,2))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c84435259.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
