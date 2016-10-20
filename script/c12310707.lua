--Crossbreed Priscilla
--lua script by SGJin
function c12310707.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2830693,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c12310707.spcon)
	e2:SetTarget(c12310707.sptg)
	e2:SetOperation(c12310707.spop)
	c:RegisterEffect(e2)
end
function c12310707.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c12310707.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_ATTACK) 
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,2,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12310707.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()<2 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_ATTACK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,2,2,nil)
		local tg=sg:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		while tg do
			local e1=Effect.CreateEffect(tg)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+0x47c0000)
			tg:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_RACE)
			e2:SetValue(RACE_ALL)
			tg:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
			e3:SetValue(0xff)
			tg:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(0)
			tg:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(0)
			tg:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e6:SetValue(1)
			tg:RegisterEffect(e6,true)
			local e7=e1:Clone()
			e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e7:SetValue(1)
			tg:RegisterEffect(e7,true)
			tg:RegisterFlagEffect(12310707,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_BATTLE,0,1,fid)
			tg:SetStatus(STATUS_NO_LEVEL,true)
			Duel.MoveToField(tg,tp,tp,LOCATION_MZONE,POS_FACEDOWN_ATTACK,true)
			Duel.RaiseEvent(tg,EVENT_MSET,e,REASON_EFFECT,tp,tp,0)
			tg=sg:GetNext()
		end
		sg:AddCard(c)
		Duel.ShuffleSetCard(sg)
		sg:RemoveCard(c)
		sg:KeepAlive()
		local de=Effect.CreateEffect(e:GetHandler())
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE+PHASE_BATTLE)
		de:SetReset(RESET_PHASE+PHASE_BATTLE)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetCountLimit(1)
		de:SetLabel(fid)
		de:SetLabelObject(sg)
		de:SetOperation(c12310707.desop)
		Duel.RegisterEffect(de,tp)
	end
end
function c12310707.desfilter(c,fid)
	return c:GetFlagEffectLabel(12310707)==fid
end
function c12310707.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c12310707.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
