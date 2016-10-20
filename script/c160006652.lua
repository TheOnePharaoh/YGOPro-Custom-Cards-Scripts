--Skull Mail Katastor
function c160006652.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,500314775,160004210,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160006652,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c160006652.condition)
	e1:SetTarget(c160006652.target)
	e1:SetOperation(c160006652.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160006652,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c160006652.spcost)
	e2:SetTarget(c160006652.sptg)
	e2:SetOperation(c160006652.spop)
	c:RegisterEffect(e2)
end
function c160006652.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsSetCard(0xc81) and tc:IsLevelBelow(4) and not bc:IsSetCard(0xc81) 
		and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c160006652.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c160006652.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c160006652.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 
		and Duel.GetActivityCount(tp,ACTIVITY_FLIPSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c160006652.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:lone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e4,tp)
end
function c160006652.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se
end
function c160006652.spfilter(c,e,tp)
	return c:IsSetCard(0xc81) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160006652.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) and c160006652.spfilter(chkc,e,tp) end
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c160006652.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160006652.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,ft,ft,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c160006652.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
