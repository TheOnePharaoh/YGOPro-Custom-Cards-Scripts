--Corrupted Vocaloid Marie And Luise Type - 01
function c76973412.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c76973412.syncon)
	e1:SetOperation(c76973412.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c76973412.descon)
	e2:SetCost(c76973412.descost)
	e2:SetTarget(c76973412.destg)
	e2:SetOperation(c76973412.desop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76973412,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c76973412.cost)
	e3:SetOperation(c76973412.operation)
	c:RegisterEffect(e3)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76973412,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c76973412.cdspsum)
	e4:SetTarget(c76973412.tgspsum)
	e4:SetOperation(c76973412.opspsum)
	c:RegisterEffect(e4)
end
function c76973412.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c76973412.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c76973412.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
	return g1:IsExists(c76973412.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c76973412.synfilter3,1,nil,lv-tlv)
	end	
end
function c76973412.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c76973412.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c76973412.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973412.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c76973412.synfilter1,1,nil,lv,g1,g2)
end
function c76973412.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c76973412.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973412.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c76973412.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c76973412.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c76973412.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973412,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973412,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973412,4))
end
function c76973412.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c76973412.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c76973412.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c76973412.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c76973412.filter(c)
	return c:IsLevelBelow(12) and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x301) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c76973412.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c76973412.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76973412.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c76973412.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END, 1)
	end
end
function c76973412.cdspsum(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c76973412.tgspsum(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,PLAYER_NONE,false,false,POS_FACEUP,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,0,1,1,nil,e,0,PLAYER_NONE,false,false,POS_FACEUP,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c76973412.opspsum(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
